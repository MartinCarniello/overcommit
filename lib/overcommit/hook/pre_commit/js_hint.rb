module Overcommit::Hook::PreCommit
  # Runs `jshint` against any modified JavaScript files.
  #
  # @see http://jshint.com/
  class JsHint < Base
    def run
      result = execute(command + applicable_files)
      output = result.stdout.chomp

      return :pass if result.success? && (output.empty? || output.match(/0 error/))

      # example message:
      #  path/to/file.js: line 1, col 0, Error message (E001)
      extract_messages(output.split("\n")[0..-3],
       /^(?<file>[^:]+): line (?<line>\d+), col \d+, (?<message>.*)/
      )
    end
  end
end
