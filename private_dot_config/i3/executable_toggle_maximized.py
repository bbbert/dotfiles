import i3ipc
import subprocess

i3 = i3ipc.Connection()

def get_workspace_size(ws):
    for output in i3.get_outputs():
        if output.current_workspace == ws.name:
            return output.rect.width, output.rect.height

def maximize(con):
    w, h = get_workspace_size(con.workspace())
    con.command('floating enable')
    con.command('resize set width {} px height {} px'.format(w, h))
    con.command('move position 0 px 0 px')

def minimize(con):
    con.command('floating disable')

if __name__ == '__main__':
    current = i3.get_tree().find_focused()
    if current.floating in ['user_off', 'auto_off']:
        maximize(current)
    else:
        minimize(current)
