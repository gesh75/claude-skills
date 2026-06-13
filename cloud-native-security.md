---
name: cloud-native-security
description: Cloud-native security - runtime protection, eBPF, Falco, admission control, container scanning
category: [security, advanced]
version: 1.0.0
---

# Cloud-Native Security

## Container Security Pipeline

```yaml
# 1. Build Time
dockerfile:
  FROM ubuntu:22.04
  RUN apt-get update && apt-get install -y nginx
  # Scan with Trivy, Grype for vulnerabilities
  # Sign image with cosign

# 2. Registry
# Push signed image to ECR/GCR
# Image policy: reject unsigned images
# Scan for secrets with TruffleHog

# 3. Deployment
# Admission controller checks:
# - Image signature
# - Vulnerability threshold (CVSS < 7)
# - Resource limits defined
# - Security context enforced

# 4. Runtime
# Falco monitors for:
# - Shell spawned in container
# - Privilege escalation attempt
# - Suspicious network connection
```

## Runtime Protection with Falco

```yaml
# Falco rules
- rule: Unauthorized Process
  desc: Detect suspicious processes
  condition: >
    spawned_process and
    container and
    proc.name not in (nginx, postgres, redis)
  output: >
    Suspicious process spawned
    (user=%user.name command=%proc.cmdline)
  priority: WARNING

- rule: Exfiltration Detection
  desc: Detect large data transfer
  condition: >
    outbound and
    container and
    fd.snet not in (internal_subnets) and
    bytes > 1000000  # 1MB
  output: >
    Potential data exfiltration
    (dest=%fd.sip bytes=%fd.wbytes)
  priority: CRITICAL

- rule: Privilege Escalation
  desc: Detect privilege escalation
  condition: >
    container and
    (syscall in (setuid, setgid, execve) or
     syscall = capset)
  output: >
    Privilege escalation attempt
    (syscall=%syscall.name)
  priority: HIGH
```

## eBPF-Based Detection

```c
// eBPF program for syscall monitoring
#include <uapi/linux/ptrace.h>
#include <net/sock.h>
#include <bcc/proto.h>

BPF_HASH(syscalls, u32, u64);

TRACEPOINT_PROBE(raw_syscalls, sys_enter) {
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 count = 0;

    count = syscalls.lookup_or_init(&pid, &count);
    (*count)++;

    if (*count > 1000) {  // Threshold
        bpf_trace_printk("Suspicious syscall rate: %d", pid);
    }

    return 0;
}

// Compile and load:
// clang -O2 -c syscall_monitor.c
// llvm-objcopy -O elf syscall_monitor.o
// bpftool prog load syscall_monitor.o type tracepoint
```

## Network Policy & Service Mesh

```yaml
# Kubernetes NetworkPolicy
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress

---
# Allow specific traffic
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-app
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - port: 5432

# Istio mTLS enforcement
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
spec:
  mtls:
    mode: STRICT  # Require mTLS for all traffic
```

## Admission Controllers

```python
# Kubernetes ValidatingAdmissionWebhook
# Python webhook for image policy enforcement

from flask import Flask, request, jsonify
import json

app = Flask(__name__)

@app.route('/validate', methods=['POST'])
def validate_image():
    admission_review = request.get_json()
    pod = admission_review['request']['object']

    allowed = True
    message = ""

    for container in pod['spec']['containers']:
        image = container['image']

        # Check 1: Image must be from approved registry
        if not image.startswith('ecr.aws/mycompany/'):
            allowed = False
            message = f"Image not from approved registry: {image}"

        # Check 2: Image must have tag (no latest)
        if ':latest' in image or ':' not in image:
            allowed = False
            message = f"Image must have specific tag, not latest"

        # Check 3: Check image signature
        if not verify_signature(image):
            allowed = False
            message = f"Image signature verification failed"

        # Check 4: Scan for vulnerabilities
        vulns = scan_image(image)
        if any(v['severity'] == 'CRITICAL' for v in vulns):
            allowed = False
            message = f"Image has critical vulnerabilities"

    # Return admission response
    admission_response = {
        'apiVersion': 'admission.k8s.io/v1',
        'kind': 'AdmissionReview',
        'response': {
            'uid': admission_review['request']['uid'],
            'allowed': allowed,
            'message': message
        }
    }

    return jsonify(admission_response)

def verify_signature(image):
    # Use Notary or cosign to verify image signature
    return True

def scan_image(image):
    # Use Trivy or Grype to scan
    return []
```

## Supply Chain Security

```yaml
# SLSA Framework (Supply chain Levels for Software Artifacts)

Level 1: Build process is scripted and tracked
- [ ] Build process documented
- [ ] Provenance recorded (who built, when, from what)
- [ ] Configuration under version control

Level 2: Build platform is isolated and hardened
- [ ] Build platform managed separately
- [ ] Access controls enforced
- [ ] Build logs preserved

Level 3: Build platform integration is hardened
- [ ] Artifact signing required
- [ ] Provenance non-falsifiable
- [ ] Dependency tracking

Level 4: Build platform is hardened and isolated
- [ ] Hermetic builds (reproducible, no external input)
- [ ] Signed provenance
- [ ] Complete supply chain integrity
```

## Secrets Management

```yaml
# Sealed Secrets in Kubernetes
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: mysecret
  namespace: mynamespace
spec:
  encryptedData:
    password: AgBvF4... (encrypted)
  template:
    metadata:
      name: mysecret
      namespace: mynamespace
    type: Opaque

# Decrypt by sealed-secrets controller:
kubectl apply -f sealed-secret.yaml
# Controller decrypts and creates actual Secret

# Alternative: External Secrets Operator
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: aws-secrets
spec:
  provider:
    aws:
      service: SecretsManager
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets

---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: mysecret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets
    kind: SecretStore
  target:
    name: mysecret
    creationPolicy: Owner
  data:
  - secretKey: password
    remoteRef:
      key: /myapp/password
```

## Key Takeaways

- **Container scanning**: Multiple stages (build, registry, runtime)
- **Runtime monitoring**: Falco/eBPF for syscall detection
- **Network policy**: Deny-all default, allow specific flows
- **Admission control**: Enforce image policies at deployment
- **Secrets**: Never commit, use sealed secrets or external manager
- **Supply chain**: Track provenance with SLSA framework
