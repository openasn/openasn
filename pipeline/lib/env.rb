# frozen_string_literal: true

# Shared environment for all pipeline stages: canonical paths, logging, and
# the handful of constants that must match the artifact format spec.
#
# Everything under build/ is disposable and gitignored:
#   build/cache/  - raw upstream downloads (+ etag state), kept between runs
#   build/work/   - intermediate normalized data for the current run
#   build/dist/   - the artifacts we publish to the GitHub Release
#
# Ruby: stdlib only (see pipeline/README.md). `oj` is used opportunistically
# for the ~69MB ipverse as.json if it happens to be installed; we never
# depend on it (see lib/asjson.rb for the fallback chain).

require "fileutils"
require "json"
require "logger"
require "time"

module OpenASNPipeline
  ROOT      = File.expand_path("../..", __dir__)
  BUILD_DIR = File.join(ROOT, "build")
  CACHE_DIR = File.join(BUILD_DIR, "cache")
  WORK_DIR  = File.join(BUILD_DIR, "work")
  DIST_DIR  = File.join(BUILD_DIR, "dist")

  OVERRIDES_DIR = File.join(ROOT, "data", "overrides")
  LICENSES_DIR  = File.join(ROOT, "data", "licenses")

  # Sent on every outbound request. Some upstreams 403 UA-less clients
  # (crates.io did during the naming research; assume others do too).
  USER_AGENT = "openasn-pipeline/1.0 (+https://github.com/openasn/openasn)"

  # Artifact identity. Must stay in sync with the reader in the `openasn`
  # gem (openasn/ruby: lib/openasn/binary_format.rb) and the format spec
  # in FORMAT.md. Bump FORMAT_VERSION on any byte-layout change.
  MAGIC          = "OASN"
  FORMAT_VERSION = 0x01

  # Pipeline failures are always loud. Stages raise StageFailure with an
  # actionable message; run.rb turns that into a non-zero exit for CI.
  class StageFailure < StandardError; end

  module Env
    module_function

    def prepare_dirs!
      [CACHE_DIR, WORK_DIR, DIST_DIR].each { |d| FileUtils.mkdir_p(d) }
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |l|
        l.level = ENV["OPENASN_DEBUG"] ? Logger::DEBUG : Logger::INFO
        l.formatter = proc do |severity, datetime, _progname, msg|
          "#{datetime.utc.strftime('%H:%M:%S')} [#{severity}] #{msg}\n"
        end
      end
    end

    def log(msg)  = logger.info(msg)
    def warn(msg) = logger.warn(msg)

    def fail_stage!(msg)
      raise StageFailure, msg
    end
  end
end
