import os
import multiprocessing
import logging

# Gunicorn configuration for Render (binds to $PORT provided by the environment)


def _max_workers():
	try:
		env_workers = os.environ.get("WEB_CONCURRENCY")
		if env_workers:
			return int(env_workers)
		# sensible default: 2 * CPUs + 1
		return (multiprocessing.cpu_count() * 2) + 1
	except Exception:
		return 3


PORT = int(os.environ.get("PORT", "5000"))
bind = f"0.0.0.0:{PORT}"
workers = _max_workers()
threads = int(os.environ.get("GUNICORN_THREADS", "4"))
worker_class = os.environ.get("GUNICORN_WORKER_CLASS", "gthread")
timeout = int(os.environ.get("GUNICORN_TIMEOUT", "120"))
preload_app = True
loglevel = os.environ.get("GUNICORN_LOGLEVEL", "info")
accesslog = "-"  # stdout
errorlog = "-"   # stderr


def on_starting(server):
	logging.info("Gunicorn starting")


def post_fork(server, worker):
	logging.info(f"Worker spawned (pid: {worker.pid})")
