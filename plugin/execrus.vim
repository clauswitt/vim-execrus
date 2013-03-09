function! s:PluginMeetsCondition(plugin)
  if has_key(a:plugin, 'condition') 
    if type(a:plugin['condition']) == type(function('tr'))
      if call(a:plugin['condition'], [])
        return 1
      endif
    elseif type(a:plugin['condition']) == type("")
      return match(expand('%'), a:plugin['condition']) != -1
    endif
  else
    return 1
  endif
endfunction

function! s:FindMaximumPriorityPlugin(plugins)
  let max_plugin = {'priority': -1}

  for plugin in a:plugins
    if plugin['priority'] > max_plugin['priority'] && s:PluginMeetsCondition(plugin)
      let max_plugin = plugin
    endif
  endfor

  if max_plugin['priority'] != -1
    return max_plugin
  endif
endfunction

function! s:ExecutePlugin(plugin)
  if type(a:plugin) != type({})
    return
  endif

  if type(a:plugin['exec']) == type(function('tr'))
    call call(a:plugin['exec'], [])
  elseif type(a:plugin['exec']) == type("")
    exec a:plugin['exec']
  end
endfunction

function! g:Execrus()
  let plugin = s:FindMaximumPriorityPlugin(b:execrus_plugins)
  call s:ExecutePlugin(plugin)
endfunction

