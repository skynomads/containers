def with_process(*args)
  pid = Process.spawn(*args)
  yield
  Process.kill('INT', pid)
end
