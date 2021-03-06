# -*- encoding: utf-8 -*-
# this is required because of the use of eval interacting badly with require_relative
require 'razor/acceptance/utils'
confine :except, :roles => %w{master dashboard database frictionless}
require 'tmpdir'

test_name "Delete repo with Invalid path for JSON File"
step "https://testrail.ops.puppetlabs.net/index.php?/cases/view/663"

file = '/tmp/' + Dir::Tmpname.make_tmpname(['delete-repo-', '.json'], nil)

step 'Ensure the temporary file is absolutely not present'
on agents, "rm -f #{file}"

reset_database
razor agents, 'delete-repo', %W{--json #{file}}, exit: 1 do |agent, text|
  assert_match %r{Error: File /tmp/delete-repo.*\.json not found}, text
end

