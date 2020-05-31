

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

using DDCAction = std::pair<int, int>;
using Display = DisplayInfo;
using Displays = vector<Display>;

enum Mode {
  Read,
  Write
};

/**
 * Execute a ddc action
 * on a `std::vector<DisplayInfo>`
 *
 * @param displays
 * @param action
 */
static void executeDDCAction(const Mode mode, const Displays &displays, const DDCAction &action) {

  for (const auto &display : displays) {
    switch(mode) {
      case Mode::Read: {
        struct DDCReadCommand command{
          static_cast<UInt8>(action.first)
        };



        if (!DDCRead(display, &command)) {
          printf("E: Failed to send DDC command!\n");
        } else {
          printf("D: getting VCP control #%u => %u,%u\n", command.controlId, command.currentValue, command.maxValue);
        }
      }
        break;
      case Mode::Write: {
        struct DDCWriteCommand command{
          static_cast<UInt8>(action.first),
          static_cast<UInt8>(action.second)
        };

        printf("D: setting VCP control #%u => %u\n", command.control_id, command.new_value);

        if (!DDCWrite(display, &command)) {
          printf("E: Failed to send DDC command!\n");
        }
      }
        break;
    }



  }
}

using Actions = vector<DDCAction>;

using ActionHandler = function<void(Actions &, const cxxopts::ParseResult &)>;

static ActionHandler createValueHandler(const string name, UInt8 code) {
  return ([&name, code](Actions &actions, const cxxopts::ParseResult &opts) -> void {
    if (opts.count(name)) {
      actions.emplace_back(code, opts[name].as<int>());
    }
  });
}


int main(int argc, char **argv) {
  auto allDisplays = getDisplays();
  auto displays = getDisplays();
  auto mode = Mode::Read;

  vector<ActionHandler> handlers{
    createValueHandler(BRIGHTNESS_OPT, BRIGHTNESS),
    createValueHandler(CONTRAST_OPT, CONTRAST),
    createValueHandler(INPUT_SOURCE_OPT, INPUT_SOURCE)
  };
  vector<DDCAction> actions;

  cxxopts::Options options("ddcctl", "DDC/CI Monitor Control");
  options.add_options("common")
    ("d," DISPLAY_OPT, "Display number", cxxopts::value<int>()->default_value("-1"))
    ("b," BRIGHTNESS_OPT, "Display number", cxxopts::value<int>())
    ("s," INPUT_SOURCE_OPT, "Input Source", cxxopts::value<int>()->default_value("-1"))
    ("w,write", "Write Mode", cxxopts::value<bool>()->default_value("false"));

  options.help();
  auto opts = options.parse(argc, argv);

  if (opts["write"].as<bool>()) {
    mode = Mode::Write;
  }

  auto index = opts[DISPLAY_OPT].as<int>();
  if (index > -1) {
    displays.clear();
    displays.push_back(allDisplays[index]);
  }

  for (auto & handler : handlers) {
    handler(actions,opts);
  }
//  if (opts.count(BRIGHTNESS_OPT)) {
//    actions.emplace_back(BRIGHTNESS, opts[BRIGHTNESS_OPT].as<int>());
////    auto brightness = ;
//
//  }
  for (const auto &info : displays) {
    printf("Screen #%u: %s\n", info.index, info.name.data());


  }

  for (const auto &action : actions) {
    executeDDCAction(mode, displays, action);
  }


  return 0;
}