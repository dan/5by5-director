set :stage, :production
set :ssh_options, { forward_agent: true, port: 22022 }

server "web01.fireside.fm", user: "deploy", roles: [:app], primary: true
server "web02.fireside.fm", user: "deploy", roles: [:app]
