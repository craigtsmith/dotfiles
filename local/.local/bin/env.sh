#!/bin/sh
# Local environment initialization
# This file is sourced by shells for PATH and environment setup

# Add local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
  esac
fi
