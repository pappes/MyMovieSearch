#!/bin/bash
set -e

echo "Starting setup script for Flutter (version 3.29.2) and Android SDK..."

# --- Install Dependencies (if needed) ---
echo "Updating package lists..."
sudo apt update

echo "Installing required dependencies..."
sudo apt install -y curl git unzip  libsqlite3-0 libsqlite3-dev

# --- Install Android SDK ---
echo "Downloading and installing Android SDK command-line tools..."
if [ ! -d "android-sdk-cmdline-tools" ]; then
  # while 8512546_latest is not the latest version it has been up for a long time.
  # newer versions may only exisit for a short period of time!
  wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O android-cmdline-tools.zip
  unzip android-cmdline-tools.zip -d /tmp/android-sdk-cmdline-tools
  rm android-cmdline-tools.zip
else
  echo "Android SDK command-line tools already exist."
fi

export ANDROID_HOME=/tmp/android-sdk-cmdline-tools
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
export extra_path="$extra_path:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
echo export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator" >> $HOME/.bashrc

echo "Accepting Android SDK licenses..."
yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses

# --- Install necessary Android SDK components ---
echo "Installing required Android SDK components..."
sdkmanager --sdk_root="$ANDROID_HOME" "platforms;android-34" "build-tools;34.0.0" # Adjust versions as needed
sdkmanager --sdk_root="$ANDROID_HOME" "emulator" "platform-tools"

# --- Install Flutter Version 3.29.2 ---
echo "Downloading Flutter SDK version 3.29.2..."
if [ ! -d "/tmp/flutter" ]; then
  cd /tmp
  git clone https://github.com/flutter/flutter.git --depth 1 --branch 3.29.2
  cd -
else
  echo "Flutter SDK already exists. Attempting to checkout version 3.29.2..."
  cd /tmp/flutter
  git checkout 3.29.2
  cd -
fi

echo "Adding Flutter to PATH..."
export PATH="$PATH:/tmp/flutter/bin:/tmp/flutter/.pub-cache/bin"
export extra_path="/tmp/flutter/bin:/tmp/flutter/.pub-cache/bin"
echo "Flutter version:"
flutter --version

# --- Verify setup ---
echo "Verifying Flutter installation..."
flutter doctor

echo "Verifying Android SDK setup..."
adb version
emulator -list-avds # This might require further setup of AVDs

echo "Ensuring fluter is ready to go..."
flutter doctor
flutter pub get

echo export PATH="\$PATH:$extra_path" >> $HOME/.bashrc
echo export PATH="\$PATH:$extra_path" >> $HOME/.bash_profile
echo export PATH="\$PATH:$extra_path" >> $HOME/.profile

echo "IMPORTANT: For the PATH changes to take effect in your current interactive terminal session, you may need to source your .bashrc file (e.g., run 'source $HOME/.bashrc') or open a new terminal."

echo "Setup script completed."