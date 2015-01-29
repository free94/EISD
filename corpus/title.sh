for file in *; do lua ../nom.lua $file>tempfile; cat $file >>tempfile; mv tempfile $file; done
