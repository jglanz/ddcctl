

#include "DDC.h"
#include <cxxopts.hpp>
#include <algorithm>
#include <map>
#include <vector>
#include <string>


using std::pair;
using std::function;
using std::make_pair;
using std::vector;
using std::string;
using std::map;

using DDCAction = std::pair<int,int>;
using Display = DisplayInfo;
using Displays = vector<Display>;

static void executeDDCAction(const Displays & displays, const DDCAction & action) {

//    command.control_id = static_cast<UInt8>(action.first);
//    command.new_value = static_cast<UInt8>(action.second);


    for (const auto & display : displays) {
      struct DDCWriteCommand command {
        static_cast<UInt8>(action.first),
        static_cast<UInt8>(action.second)
      };

      printf("D: setting VCP control #%u => %u\n", command.control_id, command.new_value);

      if (!DDCWrite(display, &command)) {
        printf("E: Failed to send DDC command!\n");
      }
    }
}

using Actions = vector<DDCAction>;

using ActionHandler = function<void (const Actions&, const cxxopts::Options&)>;

static ActionHandler createValueHandler(const std::string_view name, UInt8 code) {
  return ([name,code] (const Actions& actions, const cxxopts::Options& opts) -> void {

  });
}


int main(int argc, char **argv) {
  auto allDisplays = getDisplays();
  auto displays = getDisplays();

  vector<ActionHandler> handlers {
    createValueHandler(BRIGHTNESS_OPT, BRIGHTNESS)
  };
  vector<DDCAction> actions;

  cxxopts::Options options("ddcctl", "DDC/CI Monitor Control");
  options.add_options("common")
    ("d,display", "Display number", cxxopts::value<int>()->default_value("-1"))
    ("b,brightness", "Display number", cxxopts::value<int>());

  auto opts = options.parse(argc, argv);

  auto index = opts["display"].as<int>();
  if (index > -1) {
    displays.clear();
    displays.push_back(allDisplays[index]);
  }


  if (opts.count("brightness")) {
    actions.emplace_back(BRIGHTNESS, opts["brightness"].as<int>());
//    auto brightness = ;

  }
  for (const auto &info : displays) {
    printf("Screen #%u: %s\n", info.index, info.name.data());


  }

  for (const auto & action : actions) {
    executeDDCAction(displays, action);
  }





  return 0;
}