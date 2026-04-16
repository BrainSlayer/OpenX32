#./mksquashfs4 target root.fs -comp xz -sort tools/sort.txt -nopad  -root-owned -noappend -b 262144
./mksquashfs target root.fs_new -comp xz -sort tools/sort.txt -nopad  -root-owned -noappend -b 1048576
