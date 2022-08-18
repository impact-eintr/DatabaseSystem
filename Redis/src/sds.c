#include "sds.h"
#include "zmalloc.h"

#include <stdlib.h>
#include <string.h>

sds sdsnewlen(const void *init, size_t initlen) {
  struct sdshdr *sh;

  if (init) {
    sh = zmalloc(sizeof(struct sdshdr) + initlen + 1);
  } else {
    sh = zcalloc(sizeof(struct sdshdr) + initlen + 1);
  }
  // 内存分配失败， 返回
  if (sh == NULL) {
    return NULL;
  }

  // 设置初始化长度
  sh->len = initlen;
  // 新sds不预留任何空间
  sh->free = 0;
  // 如果有指定初始化内容，将它们复制到sdshdr的buf中
  if (initlen && init) {
    memcpy(sh->buf, init, initlen);
  }
  // 以 '\0' 结尾
  sh->buf[initlen] = '\0';

  // 返回buf部分 而不是整个sdshdr
  return (char*)sh->buf;
}
sds sdsnew(const char *init) {
  size_t initlen = (init == NULL) ? 0 : strlen(init);
  return sdsnewlen(init, initlen);
}

sds sdsempty(void) {
  return sdsnewlen("", 0);
}

sds sdsdup(const sds s) {
  return sdsnewlen(s, sdslen(s));
}

void sdsfree(sds s) {
  if (s == NULL)
    return;
  zfree(s - sizeof(struct sdshdr));
}

// 扩充sds长度
sds sdsgrowzero(sds s, size_t len) {
  struct sdshdr *sh = (void *)(s - (sizeof(struct sdshdr)));
  size_t totlen, curlen = sh->len;

  // 如果 len 比较字符串的现有长度小
  // 直接返回
  if (len <= curlen)
    return s;

  s = sdsMakeRoomFor(s, len - curlen);
  // 如果内存不足 直接返回
  if (s == NULL)
    return NULL;

  // 将新分配的空间用0填充 防止出现垃圾内容
  sh = (void *)(s - sizeof(struct sdshdr));
  memset(s + curlen, 0, (len - curlen + 1));

  // 更新属性
  totlen = sh->len + sh->free;
  sh->len = len;
  sh->free = totlen - sh->len;

  // 返回新的 sds
  return s;
}

// 追加长度为 len 的一个字符串到另一个字符串
sds sdscatlen(sds s, const void *t, size_t len) {
  struct sdshdr *sh;

  // 原有字符串长度
  size_t curlen = sdslen(s);

  // 扩展 sds 空间
  s = sdsMakeRoomFor(s, len);

  // 内存不足？直接返回
  if (s == NULL) return NULL;

  // 复制数据
  memcpy(s+curlen, t, len);

  // 更新属性
  sh = (void *)(s - (sizeof(struct sdshdr)));
  sh->len = curlen + len;
  sh->free -= len;

  // 添加新结尾符号
  s[curlen + len] = '\0';
  // 返回新 sds
  return s;
}

// 追加字符串 s + t
sds sdscat(sds s, const char *t) {
  return sdscatlen(s, t, strlen(t));
}

sds sdscatsds(sds s, const sds t) {
  return sdscatlen(s, t, sdslen(t));
}

sds sdscpylen(sds s, const char *t, size_t len) {
  struct sdshdr *sh = (void *)(s - (sizeof(struct sdshdr)));

  // sds 现有 buf 的长度
  size_t totlen = sh->free + sh->len;

  if (totlen < len) {
    s = sdsMakeRoomFor(s, len-sh->len);
    if (s == NULL) return NULL;
    sh = (void *)(s - sizeof(struct sdshdr));
    totlen = sh->free + sh->len;
  }

  // 复制内容
  memcpy(s, t, len);
  // 添加终结符号
  s[len] = '\0';
  // 更新属性
  sh->len = len;
  sh->free = totlen - len;
  // 返回新的 sds
  return s;
}


sds sdscpy(sds s, const char *t) {

}

sds sdscatvprintf(sds s, const char *fmt, va_list ap);
#ifdef __GNUC__
sds sdscatprintf(sds s, const char *fmt, ...)
    __attribute__((format(printf, 2, 3)));
#else
sds sdscatprintf(sds s, const char *fmt, ...);
#endif

sds sdscatfmt(sds s, char const *fmt, ...);
sds sdstrim(sds s, const char *cset);
void sdsrange(sds s, int start, int end);
void sdsupdatelen(sds s);
void sdsclear(sds s);
int sdscmp(const sds s1, const sds s2);
sds *sdssplitlen(const char *s, int len, const char *sep, int seplen,
                 int *count);
void sdsfreesplitres(sds *tokens, int count);
void sdstolower(sds s);
void sdstoupper(sds s);
sds sdsfromlonglong(long long value);
sds sdscatrepr(sds s, const char *p, size_t len);
sds *sdssplitargs(const char *line, int *argc);
sds sdsmapchars(sds s, const char *from, const char *to, size_t setlen);
sds sdsjoin(char **argv, int argc, char *sep);

/* Low level functions exposed to the user API */
sds sdsMakeRoomFor(sds s, size_t addlen) {
  struct sdshdr *sh, *newsh;

  // 获取 s 目前的空余空间长度
  size_t free = sdsavail(s);

  size_t len, newlen;

  if (free > addlen)
    return s;

  len = sdslen(s);
  sh = (void *)(s - (sizeof(struct sdshdr)));

  // s 最少需要的长度
  newlen =(len + addlen);

  if (newlen < SDS_MAX_PREALLOC)
    newlen *= 2;
  else
    newlen += SDS_MAX_PREALLOC;
  newsh = zrealloc(sh, sizeof(struct sdshdr) + newlen + 1);

  // 内存不足 分配失败 返回
  if (newsh == NULL)
    return NULL;

  newsh->free = newlen - len;

  // 返回 sds
  return newsh->buf;
}

void sdsIncrLen(sds s, int incr);
sds sdsRemoveFreeSpace(sds s);
size_t sdsAllocSize(sds s);
