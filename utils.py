"""
Utility functions for the project
"""

def format_output(data):
    """Format data for display"""
    return f"Formatted: {data}"

def validate_input(user_input):
    """Validate user input"""
    # Basic validation
    return user_input is not None and len(str(user_input)) > 0

def load_config():
    """Load configuration from file"""
    # TODO: Implement config loading
    return {}