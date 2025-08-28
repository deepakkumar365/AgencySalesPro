from functools import wraps
from flask import session, request, current_app
from flask_jwt_extended import get_jwt_identity, verify_jwt_in_request
from app import db
from models import ActivityLog

def log_activity(action):
    """Decorator to log user activities"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            user_id = None
            # Try to get user_id from session for web routes
            if 'user_id' in session:
                user_id = session.get('user_id')
            else:
                # Try to get user_id from JWT for API routes
                try:
                    verify_jwt_in_request(optional=True)
                    user_id = get_jwt_identity()
                except Exception:
                    pass # No valid JWT found

            if user_id:
                # Execute the function first
                result = f(*args, **kwargs)
                
                # Log the activity after successful execution
                try:
                    log = ActivityLog(
                        user_id=user_id,
                        action=action,
                        description=f'User performed {action}',
                        ip_address=request.remote_addr,
                        user_agent=request.headers.get('User-Agent')
                    )
                    db.session.add(log)
                    db.session.commit()
                except Exception as e:
                    # Don't fail the request, but log the error
                    current_app.logger.error(f"Failed to log activity: {e}")
                
                return result
            else:
                return f(*args, **kwargs)
        return decorated_function
    return decorator
