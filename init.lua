local M = {}

-- Place to store the file list for the current project
M.project_cache = nil

-- The currently selected project folder
M.project_folder = nil

-- Return whatever the currently selected project is, or a sane default
M.get_current_project = function()
  return M.project_folder or io.get_project_root() or (M.project_cache and M.project_cache[1])
end

-- When needed, rebuild the above cache
M.rebuild_project_cache = function()
  M.project_cache = {}
  lfs.dir_foreach(M.get_current_project(), function(fn) table.insert(M.project_cache, fn) end)
end

-- Save project cache to disk
M.save_projects = function()
  local project_file, error_message = io.open(_USERHOME .. '/.projector', 'w')
  if project_file == nil then ui.print(error_message); return end
  for i,v in ipairs(M.projects) do
    project_file:write(v .. '\n')
  end
  project_file:close()
end

-- Open or create project list
M.projects = {}
local projects_handle = io.open(_USERHOME .. '/.projector', 'r')
if projects_handle then
  while true do
    local line = projects_handle:read('*line')
    if line == nil then break end
    table.insert(M.projects, line)
  end
end

-- Open the finder dialog
M.open_file = function()
  local project = M.get_current_project()
  if project == nil then
    ui.dialogs.msgbox({
      title = 'Error',
      text = 'No project selected. Please select a project first.',
      icon = 'gtk-dialog-error'
    })
    return
  end
  if M.project_cache == nil then M.rebuild_project_cache() end
  M.rebuild_project_cache()

  local i, file_name = ui.dialogs.filteredlist({
    title = 'Find File In Project',
    informative_text = 'Find File In Project',
    columns = { 'File Name' },
    string_output = true,
    items = M.project_cache
  })
  if file_name then
    io.open_file(file_name)
  end
end

-- Open the projects listing
M.open_projects = function()
  local i, project = ui.dialogs.filteredlist({
    title = 'File Project',
    informative_text = 'Find Project',
    columns = { 'Project Name' },
    string_output = true,
    items = M.projects
  })
  if project then
    M.project_folder = project
  end
end

-- Add a new project to the projects list
M.add_new_project = function()
  local i, project = ui.dialogs.inputbox({
    title = 'Add New Project',
    informative_text = 'Type folder of new project to add.',
    text = io.get_project_root(),
    string_output = true,
    width = 400,
  })
  if project then
    table.insert(M.projects, project)
    M.save_projects()
  end
end

return M