// Class to connect to the Meilisearch search engine.
// includes methods to connect to the search engine,
// add a document in the format of a DTO,
// retrieve a document in the format of a DTO
// and perform a search returning a list of DTOs.

import 'dart:convert';

import 'package:googleapis/compute/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

const host = 'https://search.dvds.mms.pappes.net';
final apiKey = Settings().meiliadminkey;

class MeiliSearch {
  MeiliSearch({
    required String indexName,
  }) : _index = MeiliSearchClient(host, apiKey).index(indexName);

  final MeiliSearchIndex _index;

  // Add a document to the search engine.
  Future<void> addDocument(MovieResultDTO dto) async {
    final json = jsonEncode(dto.toMap(flattenRelated: true));
    await _index.addDocumentsJson(json, primaryKey: movieDTOUniqueId);
  }

  // Retrieve a document from the search engine.
  Future<MovieResultDTO?> getDocument(String uniqueId) async {
    final results = await _index.getDocument(uniqueId);
    if (results != null) {
      return results.toMovieResultDTO();
    }
    return null;
  }

  // Search the search engine for a list of documents.
  Future<List<MovieResultDTO>> search(String query) async {
    final results = await _index.search(query);
    return results.hits.map((hit) => hit.toMovieResultDTO()).toList();
  }
}

class GCP {
  String? accountJson;
  Future<void> init() async {
    Settings().init();
    await Settings().cloudSettingsInitialised;
    accountJson = Settings().seVmKey;
  }

  Future<bool> startSearchEngine() async {
    if (accountJson != null) {
      const zone = 'australia-southeast1-b';
      const instanceName = 'mms-search-engine';
      try {
        final account = jsonDecode(accountJson!) as Map;
        final projectId = account['project_id'] as String;

        final httpClient = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(accountJson),
          ['https://www.googleapis.com/auth/compute'],
        );
        // Create a Compute client.
        final compute = ComputeApi(httpClient);

        // Set the VM lifespan to 5 hours.
        // Can only be run when instance is stopped.
        try {
          await compute.instances.setScheduling(
            GcpSchedule()..seconds = (5 * 60 * 60).toString(),
            projectId,
            zone,
            instanceName,
          );
        } catch (exception) {
          // If instance is running with throw an exception.
          logger.e(exception.toString());
        }

        // Start the VM instance.
        await compute.instances.start(projectId, zone, instanceName);
      } catch (exception) {
        logger.e(exception.toString());
        return false;
      }
      return true;
    }
    return false;
  }

  Future<void> scheduleShutdown() async {
    // as per https://cloud.google.com/compute/docs/instances/schedule-instance-start-stop#gcloud
    // Delete existing schedule.
    /*  1) Find instance using the schedule
         GET https://compute.googleapis.com/compute/v1/projects/PROJECT/regions/REGION/resourcePolicies/SCHEDULE_NAME
        2) Remove the schedule from the instance
         POST https://www.googleapis.com/compute/v1/projects/PROJECT/zones/ZONE/instances/VM_NAME/removeResourcePolicies
          {
            "resourcePolicies": "https://compute.googleapis.com/compute/v1/projects/PROJECT/regions/REGION/resourcePolicies/SCHEDULE_NAME"
          } 
        3) Delete the schedule  
         DELETE https://compute.googleapis.com/compute/v1/projects/PROJECT/regions/REGION/resourcePolicies/SCHEDULE_NAME */
    // Create a new Schedule.
    /*   POST https://compute.googleapis.com/compute/v1/projects/PROJECT/regions/REGION/resourcePolicies
          {
            "name": "SCHEDULE_NAME",
            "description": "SCHEDULE_DESCRIPTION",
            "instanceSchedulePolicy": {
              "vmStartSchedule": {
                "schedule": "START-OPERATION_SCHEDULE"
              },
              "vmStopSchedule": {
                "schedule": "STOP-OPERATION_SCHEDULE"
              },
              "timeZone": "TIME_ZONE",
              "startTime":"INITIATION_DATE",
              "expirationTime":"END_DATE"
            }
          }*/
    // Attach new schedule to the started VM.
    /*    POST https://compute.googleapis.com/compute/v1/projects/PROJECT_ID/zones/ZONE/instances
          {
            "machineType": "zones/MACHINE_TYPE_ZONE/machineTypes/MACHINE_TYPE",
            "name": "VM_NAME",
            "disks": [
              {
                "initializeParams": {
                  "sourceImage": "projects/IMAGE_PROJECT/global/images/IMAGE"
                },
                "boot": true
              }
            ],
            "resourcePolicies": [
              "https://compute.googleapis.com/compute/v1/projects/PROJECT/regions/REGION/resourcePolicies/SCHEDULE_NAME"
            ]
          }*/
  }
}

class GcpSchedule extends Scheduling {
  GcpSchedule({
    this.nanos,
    this.seconds,
    super.automaticRestart,
    super.instanceTerminationAction,
    super.localSsdRecoveryTimeout,
    super.locationHint,
    super.minNodeCpus,
    super.nodeAffinities,
    super.onHostMaintenance,
    super.preemptible,
    super.provisioningModel,
  });

  GcpSchedule.fromJson(super.json_)
      : nanos = json_.containsKey('nanos') ? json_['nanos'] as int : null,
        seconds =
            json_.containsKey('seconds') ? json_['seconds'] as String : null,
        super.fromJson();

  /// A Duration represents a fixed-length span of time
  /// represented as a count of seconds and fractions of seconds
  /// at nanosecond resolution. It is independent of any calendar
  /// and concepts like "day" or "month".
  /// Range is approximately 10,000 years.
  /// Specifies the max run duration for the given instance.
  /// If specified, the instance termination action will be performed
  /// at the end of the run duration.
  int? nanos;

  /// "A String",
  /// Span of time at a resolution of a second.
  /// Must be from 0 to 315,576,000,000 inclusive.
  /// Note: these bounds are computed from:
  /// 60 sec/min * 60 min/hr * 24 hr/day * 365.25 days/year * 10000 years
  String? seconds;

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (nanos != null) map['nanos'] = nanos;
    if (seconds != null) map['seconds'] = seconds;
    return map;
  }
}
