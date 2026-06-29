return {
  'rmagatti/gx-extended.nvim',
  config = function()
    require('gx-extended').setup {
      open_fn = function(url)
        vim.fn.jobstart({ vim.fn.expand('~/scripts/xdg-open'), url }, { detach = true })
      end,
      extensions = {
        -- CDK!123 or cdk!123 → CDK GitLab repo MR (must come before generic !123 handler)
        {
          patterns = { '*' },
          name = 'CDK GitLab MR',
          match_to_url = function(line)
            local mr = line:match('[Cc][Dd][Kk]!(%d+)')
            if mr then
              return 'https://gitlab.com/ravenpack/development/operations/cloud/rp-cdk/-/merge_requests/' .. mr
            end
          end,
        },
        -- !123 → backend GitLab MR
        {
          patterns = { '*' },
          name = 'GitLab MR',
          match_to_url = function(line)
            local mr = line:match('[^%a]!(%d+)') or line:match('^!(%d+)')
            if mr then
              return 'https://gitlab.com/ravenpack/development/bigdata.com/backend/-/merge_requests/' .. mr
            end
          end,
        },
        -- |123 → backend GitLab pipeline
        {
          patterns = { '*' },
          name = 'GitLab Pipeline',
          match_to_url = function(line)
            local pipeline = line:match('[^%w]|(%d+)') or line:match('^|(%d+)')
            if pipeline then
              return 'https://gitlab.com/ravenpack/development/bigdata.com/backend/-/pipelines/' .. pipeline
            end
          end,
        },
        -- TASE-123, HDS-456, CLOUDSV-789, etc. → Jira
        {
          patterns = { '*' },
          name = 'Jira Ticket',
          match_to_url = function(line)
            local valid = { HDS=true, CLOUDSV=true, CCE=true, CPS=true, TASE=true, PX=true, CCS=true, PLAT=true, BIGDATA=true, CSS=true }
            local id = line:match('([%u][%u%d]+%-%d+)')
            if id then
              local project = id:match('^([%u%d]+)%-')
              if valid[project] then
                return 'https://ravenpack.atlassian.net/browse/' .. id
              end
            end
          end,
        },
      },
    }
  end,
}
