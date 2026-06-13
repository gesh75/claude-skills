# Django Injection / XSS / CSRF Mechanics

> For generic OWASP background on SQL injection, XSS, and CSRF (what they are and why they matter), see the **security-review** skill. Below is the Django-specific mechanics only.

## SQL Injection Prevention (Django ORM)

```python
# GOOD: Django ORM automatically escapes parameters
def get_user(username):
    return User.objects.get(username=username)  # Safe

# GOOD: Using parameters with raw()
def search_users(query):
    return User.objects.raw('SELECT * FROM users WHERE username = %s', [query])

# BAD: Never directly interpolate user input
def get_user_bad(username):
    return User.objects.raw(f'SELECT * FROM users WHERE username = {username}')  # VULNERABLE!

# GOOD: Using filter with proper escaping
def get_users_by_email(email):
    return User.objects.filter(email__iexact=email)  # Safe

# GOOD: Using Q objects for complex queries
from django.db.models import Q
def search_users_complex(query):
    return User.objects.filter(
        Q(username__icontains=query) |
        Q(email__icontains=query)
    )  # Safe
```

### Extra Security with raw()

```python
# If you must use raw SQL, always use parameters
User.objects.raw(
    'SELECT * FROM users WHERE email = %s AND status = %s',
    [user_input_email, status]
)
```

## XSS Prevention

### Template Escaping

```django
{# Django auto-escapes variables by default - SAFE #}
{{ user_input }}  {# Escaped HTML #}

{# Explicitly mark safe only for trusted content #}
{{ trusted_html|safe }}  {# Not escaped #}

{# Use template filters for safe HTML #}
{{ user_input|escape }}  {# Same as default #}
{{ user_input|striptags }}  {# Remove all HTML tags #}

{# JavaScript escaping #}
<script>
    var username = {{ username|escapejs }};
</script>
```

### Safe String Handling

```python
from django.utils.safestring import mark_safe
from django.utils.html import escape

# BAD: Never mark user input as safe without escaping
def render_bad(user_input):
    return mark_safe(user_input)  # VULNERABLE!

# GOOD: Escape first, then mark safe
def render_good(user_input):
    return mark_safe(escape(user_input))

# GOOD: Use format_html for HTML with variables
from django.utils.html import format_html

def greet_user(username):
    return format_html('<span class="user">{}</span>', escape(username))
```

## CSRF Protection

### Default CSRF Protection

```python
# settings.py - CSRF is enabled by default
CSRF_COOKIE_SECURE = True  # Only send over HTTPS
CSRF_COOKIE_HTTPONLY = True  # Prevent JavaScript access
CSRF_COOKIE_SAMESITE = 'Lax'  # Prevent CSRF in some cases
CSRF_TRUSTED_ORIGINS = ['https://example.com']  # Trusted domains

# Template usage
<form method="post">
    {% csrf_token %}
    {{ form.as_p }}
    <button type="submit">Submit</button>
</form>

# AJAX requests
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

fetch('/api/endpoint/', {
    method: 'POST',
    headers: {
        'X-CSRFToken': getCookie('csrftoken'),
        'Content-Type': 'application/json',
    },
    body: JSON.stringify(data)
});
```

### Exempting Views (Use Carefully)

```python
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt  # Only use when absolutely necessary!
def webhook_view(request):
    # Webhook from external service
    pass
```
