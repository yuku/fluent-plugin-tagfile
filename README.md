#fluent-plugin-tagfile

This is similar to the `file` build-in output plugin, but `tag_file` decides output directory using tag of events.

##Installation

```shell
% gem install fluent-plugin-tagfile
```

##Example

```conf
#/etc/fluentd/fluent.conf
<match prefix.**>
  type tag_file

  path /var/log/fluent
  compress gzip

  time_slice_format %Y/%m/%d/%H/%M
  flush_interval 10m
</match>
```

Fluent with such conf file behaves as follows.
Suppose that tag is `prefix.foo.bar` and time is `2012/02/01 18:46`.

1. Look for all events whose tag starts with `prefix.`.

2. Create buffer file in `path` directory such as `/var/log/fluent/buffer.xxxxx`.

3. In every minutes, fluent tries to flush the buffer, then `/var/log/fluent/foo/bar/2012/02/01/18/46/N.log.gz` is created. N is a unique number in the directory.

If `time_slice_format` includes `/` like this example, it is used as the directory hierarchy.

##See also

http://fluentd.org/doc/plugin.html#file
