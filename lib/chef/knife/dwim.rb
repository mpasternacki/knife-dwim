require 'pathname'

require 'chef/knife'

module KnifeDwim
  class Dwim < Chef::Knife
    banner "knife dwim [-n] FILE [FILE [FILE [...]]]"

    def run_knife(cls, *args)
      cls.load_deps
      i = cls.new(args)
      i.config = config
      i.run
    end

    def run
      if name_args.empty?
        ui.error('File name or names required')
      else
        name_args.each do |f|
          path = Pathname.
            new(f).
            expand_path

          unless path.exist?
            ui.error "Path #{path} does not exist."
            next
          end

          done = false

          Chef::Config[:cookbook_path].each do |cbp|
            rel_path = path.relative_path_from(Pathname.new(cbp).expand_path)

            if not rel_path.to_s[0..2] == '../'
              # path is within a cookbook dir
              run_knife(Chef::Knife::CookbookUpload, rel_path.to_s.sub(/\/.*/,''))
              done = true
              break
            end
          end

          next if done

          path = path.relative_path_from(Pathname.pwd)
          if path.to_s[0..2] == '../'
            ui.error "Path #{path.expand_path} is outside the repo."
            next
          end

          case path.to_s
          when /^roles\//
            run_knife(Chef::Knife::RoleFromFile, path.basename)
          when /^nodes\//
            run_knife(Chef::Knife::NodeFromFile, path.basename)
          when /^environments\//
            run_knife(Chef::Knife::EnvironmentFromFile, path.basename)
          when /^data.bags\/(\w+)\/.*\.ya?ml$/
            run_knife(Chef::Knife::DataBagFromYaml, $1, path.basename)
          when /^data.bags\/(\w+)\//
            run_knife(Chef::Knife::DataBagFromFile, $1, path.basename)
          else
            ui.error "Don't know what to do with #{path}."
          end
        end
      end
    end
  end
end
