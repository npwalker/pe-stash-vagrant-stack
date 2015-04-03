# PE Stash Vagrant Stack

The stash-server VM is setup to install stash in developer mode which is a 24-hour license.  If you remove that flag you have to get an evaluation license key which will last 30 days.  You may want to do that if you have something long standing to test. 

http://blogs.atlassian.com/2014/11/automating-stash-deployments/

You can reach the Stash UI on port 7990

username: admin
password: admin

The goal of the stack is to facilitate testing and understanding of how to use setup r10k with stash.  

As I understand it the best way to setup a post-receive hook in stash is to use the following plugin.  You'll have to do that manually for now as I haven't automated it.   

https://marketplace.atlassian.com/plugins/com.ngs.stash.externalhooks.external-hooks

## Other Notes

This is based on the puppet-debugging-kit.  

https://github.com/Sharpie/puppet-debugging-kit
