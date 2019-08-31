# Core WAF

## What is this?

https://aws.amazon.com/solutions/aws-waf-security-automations/

But for deployspec.

Read more:

https://docs.aws.amazon.com/solutions/latest/aws-waf-security-automations/welcome.html

## Testing

xss in url to test WAF:
```
# Tunnel
ssh -nN -L 9000:internal-demo-Appli-9NRMSALV2GUO-2343.ap-southeast-1.elb.amazonaws.com:80 nonprod-bastion

# 200 OK:
http://localhost:9000/hello-world
http://localhost:9000/hello-world?callback=%3Cfoo%3Ehi%3C/foo%3E

# 403 Forbidden:
http://localhost:9000/hello-world?callback=<script>alert('hi')</script>
http://localhost:9000/hello-world?callback=%3Cscript%3Ealert('hi')%3C%2Fscript%3

# Every 5 seconds
watch -n 5 'curl -I "http://localhost:9000/hello-world"'
watch -n 5 'curl -I "http://localhost:9000/hello-world?callback=%3Cscript%3Ealert(%27hi%27)%3C/script%3E"'
```
