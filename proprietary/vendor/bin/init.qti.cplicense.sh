#!/vendor/bin/sh

SRC="/vendor/etc/oem_72_prj_XiaomiWidevine4635.pfm"
DST_DIR="/mnt/vendor/persist/data/pfm/licenses"
DST="$DST_DIR/oem_72_prj_XiaomiWidevine4635.pfm"
CHECK_FILE="$DST_DIR/oem_72_prj_XiaomiWidevine4635.pfm.inst"

# 如果 .pfm.inst 文件存在，则跳过所有操作
if [ -f "$CHECK_FILE" ]; then
    log -t WidevineCopy "Skip: $CHECK_FILE exists, no copy needed"
    exit 0
fi

# 执行拷贝
cp "$SRC" "$DST"
log -t WidevineCopy "Copied File"

# 校验 MD5
SRC_MD5=$(md5sum "$SRC" | awk '{ print $1 }')
DST_MD5=$(md5sum "$DST" | awk '{ print $1 }')

if [ "$SRC_MD5" != "$DST_MD5" ]; then
    log -t WidevineCopy "MD5 mismatch, retrying copy"
    cp "$SRC" "$DST"
    DST_MD5=$(md5sum "$DST" | awk '{ print $1 }')
    if [ "$SRC_MD5" != "$DST_MD5" ]; then
        log -t WidevineCopy "MD5 check failed after retry"
    else
        log -t WidevineCopy "MD5 check passed after retry"
    fi
else
    log -t WidevineCopy "MD5 check passed"
fi
