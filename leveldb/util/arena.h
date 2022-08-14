#ifndef ARENA_H_
#define ARENA_H_

namespace leveldb {
class Arena {
public:
  Arena();

  Arena(const Arena &) = delete;
};
}; // namespace leveldb

#endif // ARENA_H_
