spawn = require('child_process').spawn

module.exports =
  activate: ->
    atom.workspaceView.command "golang:gofmt", => @gofmt()

  gofmt: ->
    # TODO: allow user to specify gofmt command, e.g. goimports
    gofmt = "/usr/local/bin/gofmt"

    editor = atom.workspace.activePaneItem
    [startRow, startColumn] = editor.getCursorBufferPosition()
    console.log(startRow, startColumn)

    try
      fmt = spawn(gofmt)

      fmt.stdin.write(editor.getText())
      fmt.stdin.end()

      newData=''
      fmt.stdout.on 'data', (data) =>
        newData += data.toString()

      fmt.on 'exit', (code)=>
        if code == 0 and newData != ''
          editor.setText(newData)
    catch
      console.log("Error running gofmt")

    editor.setCursorBufferPosition([startRow, startColumn])
