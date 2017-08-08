# Projector

This is a project management solution for the textadept text editor. It tracks a current project folder (separate from the textadept project)
and has it's own filtered search for the project. You can also switch easily between projects.

## Usage

To start, require the file in your `init.lua`, and map the commands to keys:

```lua
projector = require('textadept-projector')

-- Map the keys
keys['cp'] = projector.open_file
keys['cP'] = projector.open_projects
keys['cmp'] = projector.add_new_project
```

In this scenario, `Ctrl-p` brings up the file open list search, `Ctrl-P` brings up the project selector and `Ctrl-Meta-p` opens the dialog
to add a new project. Currently, projects are stored in `~/.textadept/.projector`. Switching projects and finding files is simple. Use the open\_projects
dialog to select your project, and open\_file dialog to search and open a file in that project. Adding a new project just uses the current version-controlled
parent folder of the current file by default, but you can enter any folder you like in the dialog.

If you want to delete a project, just remove it from the `.projector` file.

# Additional tips

Projector uses the default filter list from textadept to filter things out of the project's file listing. You can add to that list in your `init.lua`
in order to filter out additional files or folders. For example:

```lua
table.insert(lfs.default_filter.folders, 'tmp')
```

See the (textadept API manual)[https://foicica.com/textadept/api.html#lfs.default\_filter] for more details.