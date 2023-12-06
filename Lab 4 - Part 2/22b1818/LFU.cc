#include <algorithm>
#include <cassert>
#include <map>
#include <vector>

#include "cache.h"

namespace
{
std::map<CACHE*, std::vector<uint64_t>> last_used_cycles; //each vector corresponds last used cycle info for : SET1 SET2 ... and each SETi contains some number of ways
std::map<CACHE*, std::vector<uint64_t>> cache_line_frequencies;
}

void CACHE::initialize_replacement() { 
    ::last_used_cycles[this] = std::vector<uint64_t>(NUM_SET * NUM_WAY); 
    ::cache_line_frequencies[this] = std::vector<uint64_t>(NUM_SET * NUM_WAY); 
} //initializes the members for "this" cache

uint32_t CACHE::find_victim(uint32_t triggering_cpu, uint64_t instr_id, uint32_t set, const BLOCK* current_set, uint64_t ip, uint64_t full_addr, uint32_t type)
{
  auto begin = std::next(std::begin(::cache_line_frequencies[this]), set * NUM_WAY); // iterator at the start of the given set
  auto end = std::next(begin, NUM_WAY); // adds the size to the begin index so that it points just beyond the size of the set

  // Find the way whose last frequency is minimum
  auto victim = std::min_element(begin, end);

  //we increment the way
  assert(begin <= victim);
  assert(victim < end);
  return static_cast<uint32_t>(std::distance(begin, victim)); // cast protected by prior asserts -- this gives the way index
}

void CACHE::update_replacement_state(uint32_t triggering_cpu, uint32_t set, uint32_t way, uint64_t full_addr, uint64_t ip, uint64_t victim_addr, uint32_t type,
                                     uint8_t hit)
{
    // Mark the way as being used on the current cycle
    
    if (!hit || access_type{type} != access_type::WRITE){// Skip this for writeback hits
      if(hit){
        ::cache_line_frequencies[this].at(set * NUM_WAY + way)++; //increments the frequency of the given cache line since it is a hit
      }
      else{
        ::last_used_cycles[this].at(set * NUM_WAY + way) = current_cycle; //since this is a cache miss we restore the current cycle and set the frequency to zero
        ::cache_line_frequencies[this].at(set * NUM_WAY + way) = 0; 
      }
    }
}

void CACHE::replacement_final_stats() {}
