# Sockets test

import pyaudio
import numpy as np
import socket
import music21 as m21

HOST = '127.0.0.1'
PORT = 65530

SAMPLE_RATE = 44100

p = pyaudio.PyAudio()

stream = p.open(format=pyaudio.paFloat32,
                channels=1,
                rate=SAMPLE_RATE,
                output=True)


def close_stream():
    stream.stop_stream()
    stream.close()
    p.terminate()


def play_tone(frequency, duration, volume = 0.5):
    samples = (np.sin(2 * np.pi * np.arange(SAMPLE_RATE * duration) * frequency / SAMPLE_RATE)).astype(np.float32)
    stream.write(volume * samples)


def note(midi_num:int):
    return m21.note.Note(midi = midi_num).pitch.frequency

def note(name:str):
    return m21.note.Note(name).pitch.frequency


def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.bind((HOST, PORT))
            s.listen()

            conn, addr = s.accept()

            with conn:
                while True:
                    data = conn.recv(1024).decode('utf-8')

                    if not data:
                        # The connection was closed -- stop
                        break

                    # Format:   c5,0.4,1
                    name, dur, vol = tuple(data.strip().split(','))
                    play_tone(note(name), float(dur), volume = float(vol))

        finally:
            close_stream()

if __name__ == "__main__":
    main()