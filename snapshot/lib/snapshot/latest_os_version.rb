require 'open3'
require 'fastlane_core/ui/ui'

module Snapshot
  class LatestOsVersion
    def self.ios_version
      return ENV["SNAPSHOT_IOS_VERSION"] if FastlaneCore::Env.truthy?("SNAPSHOT_IOS_VERSION")
      self.version("iOS")
    end

    @versions = {}
    def self.version(os)
      @versions[os] ||= version_for_os(os)
    end

    def self.version_for_os(os)
      stdout, stderr, status = Open3.capture3('xcodebuild -version -sdk')

      matched = stdout.match(/#{os} ([\d\.]+) \(.*/)

      if matched.nil?
        FastlaneCore::UI.user_error!("Could not determine installed #{os} SDK version. Try running the _xcodebuild_ command manually to ensure it works.")
      elsif matched.length > 1
        return matched[1]
      else
        FastlaneCore::UI.user_error!("Could not determine installed #{os} SDK version. Please pass it via the environment variable 'SNAPSHOT_IOS_VERSION'")
      end
    end
  end
end
