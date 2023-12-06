#include <algorithm>
#include <array>
#include <map>
#include <optional>

#include "cache.h"
#include "msl/lru_table.h"

using namespace std;

vector<vector<int64_t>> monitoring_table;

constexpr static std::size_t TRACKER_SETS = 256;
constexpr static std::size_t TRACKER_WAYS = 4;
constexpr static int64_t PREFETCH_DEGREE = 1;
constexpr static int64_t PREFETCH_DISTANCE = 400; //to store the prefetch distance


void CACHE::prefetcher_initialize() {}

void CACHE::prefetcher_cycle_operate() {}

uint32_t CACHE::prefetcher_cache_operate(uint64_t addr, uint64_t ip, uint8_t cache_hit, bool useful_prefetch, uint8_t type, uint32_t metadata_in)
{
  if(!cache_hit){
    // check the monitoring table
    int flag = 0;
    for (int i = static_cast<int>(monitoring_table.size())-1; i >= 0; i--) {
    //for(int i=0; i<static_cast<int>(monitoring_table.size()); i++){
      if(abs(monitoring_table[i][2]) == 1 && addr <= static_cast<uint64_t>(monitoring_table[i][1]) && addr >= static_cast<uint64_t>(monitoring_table[i][0])) { // if there is a hit in the monitoring table we take it to the most recent position
        //logic for monitoring table hit
        // if there is a hit, we prefetch and shift this monitoring region
        int64_t lstreamdirn = monitoring_table[i][2];
        // Initialize prefetch state as per our rules
        
        if (lstreamdirn == 1){
          for(int64_t j=1; j<=PREFETCH_DEGREE; j++){
            uint64_t pf_addr = static_cast<uint64_t>(monitoring_table[i][1] + (j<<LOG2_BLOCK_SIZE)); //end_address+1, ... end_address + degree
            this->prefetch_line(pf_addr, true, 1);
          }
        }
        else{
          for(int64_t j=1; j<=PREFETCH_DEGREE; j++){
            uint64_t pf_addr = static_cast<uint64_t>(monitoring_table[i][0] - (j<<LOG2_BLOCK_SIZE)); // again end address
            this->prefetch_line(pf_addr, true, 1);
          }
        }
        //now we update the monitoring region
        monitoring_table[i][0] += lstreamdirn*(PREFETCH_DEGREE<<LOG2_BLOCK_SIZE);
        monitoring_table[i][1] += lstreamdirn*(PREFETCH_DEGREE<<LOG2_BLOCK_SIZE);
        
        // we update it to mru
        vector<int64_t> temp = monitoring_table[i];
        for (uint64_t j = i; j < monitoring_table.size() - 1; j++) {
          monitoring_table[j] = monitoring_table[j + 1];
        }
        monitoring_table[monitoring_table.size() - 1] = temp;

        flag = 1;
        return metadata_in;
      }
      else if(abs(monitoring_table[i][2]) != 1){
        if(monitoring_table[i][2] == 5){ // Y define
          int64_t X = monitoring_table[i][0];
          if((static_cast<int64_t>(addr) - X >= 0) && abs(static_cast<int64_t>(addr) - X) <= PREFETCH_DISTANCE){
            monitoring_table[i][2] = 2; // Initiates a global stream
            monitoring_table[i][1] = addr; // Sets the Y
            flag = 1;
            return metadata_in;
          }
          else if(static_cast<int64_t>(addr) - static_cast<int64_t>(X) < 0 && abs(static_cast<int64_t>(addr) - static_cast<int64_t>(X)) <= static_cast<int64_t>(PREFETCH_DISTANCE)) {
            monitoring_table[i][2] = -2; // It is on its way to being activated
            monitoring_table[i][1] = monitoring_table[i][0]; // Sets the X -- start address
            monitoring_table[i][0] = addr; // Sets the Y -- second address
            flag = 1;
            return metadata_in;
          }
          monitoring_table.erase(monitoring_table.begin()+i);
          continue;
        } 
        else if(monitoring_table[i][2] == 2 || monitoring_table[i][2] == -2){ // confirmation
          int64_t X=0;
          int64_t Y=0;
          if(monitoring_table[i][2] == 2){
            X = monitoring_table[i][0];
            Y = monitoring_table[i][1];
          }
          if(monitoring_table[i][2] == -2){
            X = monitoring_table[i][1];
            Y = monitoring_table[i][0];
          }
          if(abs(static_cast<int64_t>(addr) - X) <= PREFETCH_DISTANCE && (static_cast<int64_t>(addr) - X)*(Y - X) >= 0 && abs(static_cast<int64_t>(addr) - X) > abs(X - Y)) {
            // If all the conditions for prefetcher are satisfied
            if(static_cast<int64_t>(addr) - X > 0) {
              monitoring_table[i][1] = X + PREFETCH_DISTANCE;
              monitoring_table[i][2] = 1;
              flag = 1;
              return metadata_in;
            }
            else{
              monitoring_table[i][0] = X - PREFETCH_DISTANCE;
              monitoring_table[i][2] = -1;
              flag = 1;
              return metadata_in;
            }
          }
          monitoring_table.erase(monitoring_table.begin()+i);  //add i-- if the order is 0->end
          continue;
        } 
      }
    }
    if(flag == 0){ 
      //it doesn't lie in any of the regions, we create a new region at addr and push it into the lru
      if(monitoring_table.size()==64){
        monitoring_table[0] = vector<int64_t>{static_cast<int64_t>(addr),0,5};
      }else{
        monitoring_table.insert(monitoring_table.begin(), vector<int64_t>{static_cast<int64_t>(addr),0,5});
      }
      return metadata_in;
    }
  }
  return metadata_in;
}

uint32_t CACHE::prefetcher_cache_fill(uint64_t addr, uint32_t set, uint32_t way, uint8_t prefetch, uint64_t evicted_addr, uint32_t metadata_in)
{
  return metadata_in;
}

void CACHE::prefetcher_final_stats() {}
