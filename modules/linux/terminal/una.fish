#! /usr/bin/env nix-shell
#! nix-shell -i fish -p fish -p afpfs-ng -p fuse3

# connect or disconnect AFP home server

function mount
  # mount AFP server for given user, prompt for password

  set server $argv[1]
  set user $argv[2]

  # do not store read history
  set -lx fish_history ""
  read --silent --local --prompt-str="Password: " pw
  set url afp://$user:$pw@$server

  set afpcmd (echo quit | afpcmd $url)
  # `afpcmd` is interactive, we have to check stdout
  string join \n $afpcmd | grep Error
  if test $status = 0
    string join \n $afpcmd | tail -n +2
    exit
  end

  set volumes (string join \n $afpcmd | tail -2 | head -1 | cut -d: -f2 | tr , \n | sed -e 's/ *$//' -e 's/^ *//')

  for vol in $volumes
    set -l mount $HOME/$server/$vol
    mkdir -p $mount
    set afp_client (afp_client mount $server:$vol -u $user -p $pw $mount)
    if test $status != 0
      # we may have missed something when checking status, so output that as well
      string join \n $afpcmd | tail -n +2
      string join \n $afp_client
      rmdir $mount
      rmdir $HOME/$server
      exit
    end
  end
end

function unmount
  # unmount AFP volumes
  set server $argv[1]

  for vol in (ls $HOME/$server)
    set fusermount (fusermount -u $HOME/$server/$vol > /dev/null)
    if test $status != 0
      string join \n $fusermount
      exit
    end
    rmdir $HOME/$server/$vol
  end
  rmdir $HOME/$server
end

command mount | grep una: > /dev/null
if test $status != 0
  mount una.local (whoami)
else
  unmount una.local
end
