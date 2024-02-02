import sys
import subprocess
import time
import os

log_directory = "/work/ws-tmp/g022788-bachelor/bachelor/sbatch/"

def get_active_processes_on_gpu(gpu_id):
    try:
        # Get the list of processes on the GPU
        result = subprocess.check_output(['nvidia-smi', '--query-compute-apps=pid', '--format=csv,noheader', '--id=' + str(gpu_id)])
        processes = result.decode('utf-8').strip()
        return len(processes) > 0  # Returns True if any processes are found
    except subprocess.CalledProcessError:
        return True  # Assume GPU is busy if we can't query it

def is_gpu_free(gpu_id, buffer_time=6000):
    if get_active_processes_on_gpu(gpu_id):
        print(gpu_id," is busy")
        return False

    gpu_log_file = os.path.join(log_directory, f"gpu_{gpu_id}_last_used.txt")
    if os.path.exists(gpu_log_file):
        with open(gpu_log_file, "r") as file:
            last_used_time = float(file.read())
        if time.time() - last_used_time < buffer_time:
            print(time.strftime("%H:%M:%S", time.time()), gpu_id," is busy buffer")
            return False

    return True

def mark_gpu_usage(gpu_id):
    gpu_log_file = os.path.join(log_directory, f"gpu_{gpu_id}_last_used.txt")
    with open(gpu_log_file, "w") as file:
        file.write(str(time.time()))

if __name__ == '__main__':
    gpu_id = int(sys.argv[1])
    action = sys.argv[2] if len(sys.argv) > 2 else "check"

    if action == "check":
        if is_gpu_free(gpu_id):
            sys.exit(0)  # Exit with code 0 (success) if GPU is free
        else:
            sys.exit(1)  # Exit with code 1 (failure) if GPU is not free
    elif action == "mark":
        mark_gpu_usage(gpu_id)
        sys.exit(0)
