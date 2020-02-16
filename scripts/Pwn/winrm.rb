# On Kali, need to do: gem install -r winrm
# Change username and password

require 'winrm'
    conn = WinRM::Connection.new(
      endpoint: 'http://192.168.1.1:5985/wsman',
      user: 'username',
      password: 'password',
    )

    command=""

    conn.shell(:powershell) do |shell|
      until command == "exit\n" do
        print "PS > "
        command = gets        
        output = shell.run(command) do |stdout, stderr|
          STDOUT.print stdout
          STDERR.print stderr
        end
      end    
      puts "Exiting with code #{output.exitcode}"
    end
