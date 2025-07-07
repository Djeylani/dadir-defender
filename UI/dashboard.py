import tkinter as tk
from tkinter import messagebox, scrolledtext
import os
import psutil
import threading
from PIL import Image
import pystray
import subprocess

LOG_DIR = "C:/DadirDefender/Logs"
SCRIPT_PATH = "C:/DadirDefender/Agent/monitor.ps1"
OPTIMIZER_PATH = "C:/DadirDefender/Optimizer/optimizer.ps1"
ICON_PATH = "C:/DadirDefender/UI/assets/icon.png"

def get_latest_log():
    try:
        files = [f for f in os.listdir(LOG_DIR) if f.startswith("monitor_")]
        latest = max(files, key=lambda f: os.path.getmtime(os.path.join(LOG_DIR, f)))
        with open(os.path.join(LOG_DIR, latest), "r") as f:
            return f.read()
    except:
        return "No logs found."

def run_cleanup():
    os.system(f"powershell.exe -Command \"Start-Process powershell -ArgumentList '{SCRIPT_PATH}' -Verb RunAs\"")
    messagebox.showinfo("Cleanup Triggered", "Agent script has been triggered.")

def run_optimizer():
    try:
        subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", OPTIMIZER_PATH], check=True)
        optimizer_status.config(text="✅ Optimization complete.", fg="#00ffcc")
    except subprocess.CalledProcessError as e:
        optimizer_status.config(text="❌ Optimizer failed. See log.", fg="red")
        messagebox.showerror("Error", f"Failed to run optimizer:\n{e}")

def update_metrics():
    cpu = psutil.cpu_percent()
    ram = psutil.virtual_memory()
    disk = psutil.disk_usage("C:/")

    cpu_label.config(text=f"CPU Load: {cpu}%")
    ram_label.config(text=f"RAM Usage: {round(ram.used / (1024**3), 2)} GB / {round(ram.total / (1024**3), 2)} GB")
    disk_label.config(text=f"Disk Usage: {round(disk.used / (1024**3), 2)} GB / {round(disk.total / (1024**3), 2)} GB")

    root.after(5000, update_metrics)

def show_log():
    log_text.delete(1.0, tk.END)
    log_text.insert(tk.END, get_latest_log())

root = tk.Tk()
root.title("🛡️ Dadir Defender Dashboard")
root.geometry("600x550")
root.configure(bg="#1e1e1e")

# Set custom icon
try:
    icon_img = tk.PhotoImage(file=ICON_PATH)
    root.iconphoto(False, icon_img)
except:
    print("⚠️ Icon not found or failed to load.")

title = tk.Label(root, text="Dadir Defender", font=("Segoe UI", 18, "bold"), fg="#00ffcc", bg="#1e1e1e")
title.pack(pady=10)

cpu_label = tk.Label(root, text="CPU Load: ", font=("Segoe UI", 12), fg="white", bg="#1e1e1e")
cpu_label.pack()

ram_label = tk.Label(root, text="RAM Usage: ", font=("Segoe UI", 12), fg="white", bg="#1e1e1e")
ram_label.pack()

disk_label = tk.Label(root, text="Disk Usage: ", font=("Segoe UI", 12), fg="white", bg="#1e1e1e")
disk_label.pack()

btn_frame = tk.Frame(root, bg="#1e1e1e")
btn_frame.pack(pady=10)

tk.Button(btn_frame, text="📄 View Logs", command=show_log, width=15).grid(row=0, column=0, padx=5)
tk.Button(btn_frame, text="🧹 Run Cleanup", command=run_cleanup, width=15).grid(row=0, column=1, padx=5)
tk.Button(btn_frame, text="⚙️ LLM Optimizer", command=run_optimizer, width=15).grid(row=0, column=2, padx=5)

optimizer_status = tk.Label(root, text="", font=("Segoe UI", 10), fg="white", bg="#1e1e1e")
optimizer_status.pack()

log_text = scrolledtext.ScrolledText(root, height=15, bg="#2e2e2e", fg="white", font=("Consolas", 10))
log_text.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

def quit_app(icon, item):
    icon.stop()
    root.quit()

def show_window(icon, item):
    icon.stop()
    root.after(0, root.deiconify)

def hide_window():
    root.withdraw()
    try:
        image = Image.open(ICON_PATH)
        menu = pystray.Menu(
            pystray.MenuItem("Show Dashboard", show_window),
            pystray.MenuItem("Exit", quit_app)
        )
        icon = pystray.Icon("DadirDefender", image, "Dadir Defender", menu)
        icon.run_detached()
    except Exception as e:
        print(f"Tray icon failed: {e}")

root.protocol("WM_DELETE_WINDOW", hide_window)

update_metrics()
root.mainloop()
