# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Project Context

- This repository contains Roo Code's global settings and command definitions
- Commands are defined as markdown files in the `commands/` directory using frontmatter format
- No build/lint/test commands exist - this is a configuration repository only

## Non-Obvious Patterns

- Command files use YAML frontmatter with `description` field for metadata
- Command files follow structured markdown format with numbered lists for instructions
- File naming convention: lowercase with hyphens (e.g., `clarify.md`)
- No package.json, tsconfig.json, or traditional build system present
- This is a minimal configuration repository, not a code project
