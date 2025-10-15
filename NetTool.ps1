import subprocess
import socket
import platform
import psutil

SYSTEM = platform.system().lower()

# ----------------- Ping Test -----------------
print("\n--- Ping Test ---")
try:
    if SYSTEM.startswith("win"):
        ping_cmd = ["ping", "-n", "4", "google.com"]
    else:
        ping_cmd = ["ping", "-c", "4", "google.com"]
    completed = subprocess.run(ping_cmd, capture_output=True, text=True, check=False)
    print(completed.stdout or completed.stderr)
except Exception as e:
    print(f"Ping test failed: {e}")

# ----------------- DNS Test -----------------
print("\n--- DNS Test ---")
try:
    ip = socket.gethostbyname("google.com")
    print(f"google.com IP address: {ip}")
except socket.gaierror:
    print("DNS resolution failed")

# ----------------- System Info -----------------
print("\n--- System Info ---")
print(f"OS: {platform.system()} {platform.release()}")
print(f"Architecture: {platform.machine()}")
print(f"Version: {platform.version()}")
print(f"Processor: {platform.processor()}")

# ----------------- CPU & Memory Usage -----------------
print("\n--- CPU & Memory ---")
print(f"CPU Usage: {psutil.cpu_percent(interval=1)}%")
available_memory = psutil.virtual_memory().available / (1024 * 1024)
print(f"Available Memory: {available_memory:.2f} MB")

# ----------------- Listening Ports -----------------
print("\n--- Listening Ports ---")
connections = psutil.net_connections(kind='inet')  # 'inet' for IPv4/IPv6 TCP/UDP

listening_ports = set()
for conn in connections:
    if conn.status == psutil.CONN_LISTEN:
        listening_ports.add(conn.laddr.port)

if listening_ports:
    print("Ports currently listening:", sorted(listening_ports))
else:
    print("No ports are currently listening.")

# ----------------- Traceroute -----------------
print("\n--- Traceroute to google.com ---")
try:
    import shutil
    if SYSTEM.startswith("win"):
        trace_cmd = ["tracert", "google.com"]
    else:
        # prefer traceroute, fallback to tracepath if traceroute not installed
        if shutil.which("traceroute"):
            trace_cmd = ["traceroute", "google.com"]
        elif shutil.which("tracepath"):
            trace_cmd = ["tracepath", "google.com"]
        else:
            raise FileNotFoundError("Neither traceroute nor tracepath found on system")
    completed = subprocess.run(trace_cmd, capture_output=True, text=True, check=False)
    print(completed.stdout or completed.stderr)
except Exception as e:
    print(f"Traceroute failed: {e}")
