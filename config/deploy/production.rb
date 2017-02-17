server '52.39.10.104', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/kazuyuki/.ssh/id_rsa'
