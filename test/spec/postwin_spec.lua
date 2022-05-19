local postwin = require 'scnvim.postwin'
local config = require 'scnvim.config'

describe('post window', function()
  before_each(function()
    config.postwin.float.enabled = false
    postwin.destroy()
  end)

  it('can be displayed in a split window', function()
    local id = postwin.open()
    local cfg = vim.api.nvim_win_get_config(id)
    assert.is_number(id)
    assert.is_true(postwin.is_open())
    assert.is_nil(cfg.zindex)
    postwin.close()
    local new_id = postwin.open()
    assert.is_number(new_id)
    assert.are_not.equal(id, new_id)
  end)

  it('can be displayed in a floating window', function()
    config.postwin.float.enabled = true
    local id = postwin.open()
    local cfg = vim.api.nvim_win_get_config(id)
    assert.is_number(id)
    assert.is_true(postwin.is_open())
    assert.not_nil(cfg.zindex)
    postwin.close()
    local new_id = postwin.open()
    assert.is_number(new_id)
    assert.are_not.equal(id, new_id)
  end)

  it('can add lines to its buffer', function()
    local id = postwin.open()
    local expected = '-> this is some output'
    postwin.post(expected)
    local lines = vim.api.nvim_buf_get_lines(postwin.buf, -2, -1, true)
    assert.equals(1, #lines)
    assert.are.equal(lines[1], expected)
  end)
end)