for file in *; do echo $file >tempfile; cat $file >>tempfile; mv tempfile $file; done
