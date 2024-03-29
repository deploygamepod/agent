package controller

import (
	"gamepod.cc/agent/pkg/controller/gameserver"
)

func init() {
	// AddToManagerFuncs is a list of functions to create controllers and add them to a manager.
	AddToManagerFuncs = append(AddToManagerFuncs, gameserver.Add)
}
