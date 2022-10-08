def with_process(*args)
  pid = Process.spawn(*args, pgroup: true)
  yield
  Process.kill('-INT', pid)
  begin
    status = Timeout.timeout(5) do
      Process.waitpid(pid, Process::WNOHANG)
    end
  rescue Timeout::Error
    Process.kill('-KILL', pid)
  end
end
