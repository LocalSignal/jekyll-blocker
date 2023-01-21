module JekyllBlocker
  class Commands < Jekyll::Command
    class << self
      def init_with_program(prog)
        config = Config.new Dir.pwd

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
            sub_command.alias(:n)

            sub_command.action do |_, options|
              ActionNew.new(config).run
            end
          end
          c.command(:routes) do |sub_command|
            sub_command.syntax "blocker routes [options]"
            sub_command.description 'Show site routes'
            sub_command.alias(:r)

            sub_command.action do |_, options|
              ActionRoutes.new(config).run
            end
          end
          c.command(:validate) do |sub_command|
            sub_command.syntax "blocker validate [options]"
            sub_command.description 'Show site validate'
            sub_command.alias(:v)

            sub_command.action do |_, options|
              ActionValidate.new.run
            end
          end

          c.default_command :version
        end
      rescue ContainsBlockerFolderError
        puts "Site already contains blocker folder"
      rescue NotJekyllSiteError
        puts "Current folder does not appear to be a Jekyll site"
      end
    end
  end
end
