# These commands (fetchall, pullall, lsg) behave similarly.
# They take any number of command line args that are paths.
# Paths need to be able to be figured out by File.expand_path.
# Globbing on the shell and letting it pass in paths is the prefered situation.
#
# Takes any number of paths, absolute or relative as command line arguments.  If
# no arguments, uses CWD.  It also looks in all subdirectories of the directories passed in.
# Allows you to do `lsg ~/my_projects` or `lsg ~/my_projects/{some_project,some_other_project}`
#
# Exposes a global var called REPO_PATHS that are absolute paths of repos, ready to be processed.

# colorize hack
class String
  def colorize(color_code) "\e[#{color_code}m#{self}\e[0m" end
  def bold; colorize(1) end
  def red; colorize(31) end
  def green; colorize(32) end
  def yellow; colorize(33) end
  def cyan; colorize(36) end
end

def add_subdirectories(accum, path)
  accum.push path
  accum.concat Dir.entries(path).map {|entry| File.join(path, entry)}
end

def is_git_repo(path)
  File.basename(path) != '.' &&
  File.basename(path) != '..' &&
  File.directory?(File.join(path, '.git'))
end

paths = (ARGV.length === 0) ? [Dir.pwd] : ARGV

REPO_PATHS = paths.map { |p| File.expand_path p }
  .select { |p| File.directory? p }
  .reduce([]) { |accum, p| add_subdirectories accum, p }
  .select { |p| is_git_repo p }
