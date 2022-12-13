module JekyllBlocker
  class BlockerCommand < Jekyll::Command
    class << self
      def init_with_program(prog)
        prog.command(:blocker) do |c|
          c.syntax "blocker [command] [options]"
          c.description 'Blocker specific commands'


          c.command(:version) do |sub_command|
            sub_command.syntax "blocker version"
            sub_command.action do |_, options|
              puts JekyllBlocker::VERSION
            end
          end
          c.command(:new) do |sub_command|
            sub_command.syntax "blocker new [options]"
            sub_command.description 'Setup site to use blocker'

            sub_command.action do |_, options|
              begin
                BlockerNewAction.new(Dir.pwd).run
              rescue ContainsBlockerFolderError
                puts "Site already contains blocker folder"
              rescue NotJekyllSiteError
                puts "Current folder does not appear to be a Jekyll site"
              end
            end
          end
          c.command(:pages) do |sub_command|
            sub_command.syntax "blocker pages [options]"
            sub_command.description 'Show site pages'

            sub_command.action do |_, options|
              begin
                BlockerShowPagesAction.new(Dir.pwd).run
              rescue NotJekyllSiteError
                puts "Current folder does not appear to be a Jekyll site"
              end
            end
          end

          c.default_command :version
        end
      end
    end
  end
end
