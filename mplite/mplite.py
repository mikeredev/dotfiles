import os
import subprocess
import signal
import time
import argparse

class MusicPlayer:
    def __init__(self):
        self.current_process = None
        self.pid_file = os.path.join(os.getcwd(), "/tmp/mplite.pid")
        self.playlist_file = os.path.join(os.getcwd(), "/tmp/mplite-playlist.txt")
        self.index_file = os.path.join(os.getcwd(), "/tmp/mplite-index.txt")

    def send_notification(self, track):
        notification_text = f"Now playing: {track}"
        subprocess.run(["dunstify", "now playing", track])

    def play_music(self, file_name):
        file_path = os.path.join(os.getcwd(), file_name)

        ffmpeg_command = ["ffmpeg", "-i", file_path, "-f", "s16le", "-acodec", "pcm_s16le", "-ar", "44100", "-ac", "2", "-"]
        aplay_command = ["aplay", "-f", "cd", "-"]

        self.current_process = subprocess.Popen(
            ffmpeg_command,
            stdout=subprocess.PIPE,
            preexec_fn=os.setsid
        )
        self.write_pid(self.current_process.pid)
        self.send_notification(file_name)
        aplay_process = subprocess.Popen(
            aplay_command,
            stdin=self.current_process.stdout,
            preexec_fn=os.setsid
        )

        # Wait for the processes to finish
        self.current_process.wait()
        aplay_process.wait()

    def write_pid(self, pid):
        with open(self.pid_file, "w") as f:
            f.write(str(pid))

    def read_pid(self):
        try:
            with open(self.pid_file, "r") as f:
                return int(f.read().strip())
        except FileNotFoundError:
            return None

    def remove_pid_file(self):
        try:
            os.remove(self.pid_file)
        except FileNotFoundError:
            pass

    def remove_index_file(self):
        try:
            os.remove(self.index_file)
        except FileNotFoundError:
            pass

    def pause_music(self):
        pid = self.read_pid()
        if pid:
            os.kill(pid, signal.SIGSTOP)

    def resume_music(self):
        pid = self.read_pid()
        if pid:
            os.kill(pid, signal.SIGCONT)

    def stop_music(self, cleanup=False):
        pid = self.read_pid()
        if pid:
            os.kill(pid, signal.SIGTERM)
        self.remove_pid_file()
        if cleanup:
            self.remove_index_file()

    def next_track(self):
        current_index = self.read_index()
        current_index = (current_index + 1) % len(self.get_playlist())
        self.write_index(current_index)
        self.play_current_track()

    def prev_track(self):
        current_index = self.read_index()
        current_index = (current_index - 1) % len(self.get_playlist())
        self.write_index(current_index)
        self.play_current_track()

    def play_current_track(self):
        current_index = self.read_index()
        track_name = self.get_playlist()[current_index]
        self.stop_music()
        time.sleep(1)  # Add a delay to ensure previous track processes have terminated
        self.play_music(track_name)

    def get_playlist(self):
        try:
            with open(self.playlist_file, "r") as f:
                return f.read().splitlines()
        except FileNotFoundError:
            return []

    def read_index(self):
        try:
            with open(self.index_file, "r") as f:
                return int(f.read().strip())
        except FileNotFoundError:
            return 0

    def write_index(self, index):
        with open(self.index_file, "w") as f:
            f.write(str(index))

def select_music_folder():
    music_folder = os.path.expanduser("~/music")
    folders = [f for f in os.listdir(music_folder) if os.path.isdir(os.path.join(music_folder, f))]
    
    # Use rofi for interactive folder selection
    rofi_command = ["rofi", "-dmenu", "-i", "-p", "Select a folder:", "-lines", str(len(folders))]
    rofi_process = subprocess.Popen(rofi_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
    selected_folder, _ = rofi_process.communicate(input='\n'.join(folders))

    if rofi_process.returncode == 0 and selected_folder:
        return os.path.join(music_folder, selected_folder.strip())
    else:
        print("Folder selection canceled.")
        exit()

def main():
    parser = argparse.ArgumentParser(description="Simple music player with play, pause, stop, next, and prev actions.")
    parser.add_argument("--action", choices=["play", "pause", "resume", "stop", "next", "prev"], help="Action to perform.")
    args = parser.parse_args()
    player = MusicPlayer()

    try:
        if args.action:
            # Action is provided, perform the specified action
            if args.action == "play":
                playlist = player.get_playlist()
                if playlist:
                    player.play_music(playlist[0])
            elif args.action == "pause":
                player.pause_music()
            elif args.action == "resume":
                player.resume_music()
            elif args.action == "stop":
                player.stop_music(cleanup=True)
            elif args.action == "next":
                player.next_track()
            elif args.action == "prev":
                player.prev_track()
        else:
            # No action provided, let the user select a music folder interactively
            selected_folder = select_music_folder()

            # Display the paths to the files inside the selected folder in playlist.txt
            files = sorted(os.listdir(selected_folder))
            with open(player.playlist_file, "w") as f:
                f.write("\n".join(os.path.join(selected_folder, file) for file in files))
            print(f"Playlist created in {player.playlist_file}")
            playlist = player.get_playlist()
            if playlist:
                player.play_music(playlist[0])

    except KeyboardInterrupt:
        # Handle keyboard interrupt (Ctrl+C) to ensure proper cleanup
        player.stop_music(cleanup=True)
        print("\nMusic playback stopped.")

if __name__ == "__main__":
    main()
