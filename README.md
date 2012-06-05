#fluent-plugin-tagfile

This is similar to the `file` build-in output plugin, but `tag_file` decides output directory using tag of events.

##How to use

Puts out_tag_file.rb to plugin directory.

```shell
% cp out_tag_file.rb path/to/fluent/plugin
```

Edit conf file.

```shell
% edit path/to/fluent/fluent.conf
```

```conf
<match prefix.**>
  type tag_file
  path /path/to/log/dir/buffer
  time_format %Y/%m/%d/%H
  time_slice_format %Y%m%d%H%M  # see FileSliceOutput class
  compress gzip
</match>
```

Don't forget to set `path` as /path/to/log/dir/**BUFFER** and add write permission for */path/to/log/dir* directory to the user of fluent process.

Fluent with such conf file behaves as follows. Suppose that the tag is `prefix.hoge.homu` and time is 2012/02/01 18:46.

1. Look for all events whose tag starts with `prefix.`

2. Keep the event in the buffer file named /path/to/log/dir/buffer.*****

3. When the buffer is full, these data are written in /path/to/log/dir/hoge/homu/2012/02/01/18/0.log.gzip

Fluent will flush bufferd data in every `time_slice_format` defaults to `%Y%m%d`. In this case, data are flushed in every minute.
