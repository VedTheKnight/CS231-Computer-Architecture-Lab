#include <algorithm>
#include <cassert>
#include <map>
#include <vector>

#include "cache.h"

namespace
{
std::map<CACHE*, std::vector<uint64_t>> last_used_cycles; //each vector corresponds last used cycle info for : SET1 SET2 ... and each SETi contains some number of ways
}

void CACHE::initialize_replacement() { ::last_used_cycles[this] = std::vector<uint64_t>(NUM_SET * NUM_WAY); } //initializes the members for "this" cache

uint32_t CACHE::find_victim(uint32_t triggering_cpu, uint64_t instr_id, uint32_t set, const BLOCK* current_set, uint64_t ip, uint64_t full_addr, uint32_t type)
{
  auto begin = std::next(std::begin(::last_used_cycles[this]), set * NUM_WAY); // iterator at the start of the given set
  auto end = std::next(begin, NUM_WAY); // adds the size to the begin index so that it points just beyond the size of the set

  // Find the way whose last use cycle is most distant
  auto victim = std::min_element(begin, end);
  assert(begin <= victim);
  assert(victim < end);
  return static_cast<uint32_t>(std::distance(begin, victim)); // cast protected by prior asserts -- this gives the way index
}

void CACHE::update_replacement_state(uint32_t triggering_cpu, uint32_t set, uint32_t way, uint64_t full_addr, uint64_t ip, uint64_t victim_addr, uint32_t type,
                                     uint8_t hit)
{
  // Mark the way as being used on the current cycle
  if (!hit) //whenever there is a miss we add in the current cycle at that index. This keeps track of when new lines are introduced
    ::last_used_cycles[this].at(set * NUM_WAY + way) = current_cycle;
}

void CACHE::replacement_final_stats() {}
