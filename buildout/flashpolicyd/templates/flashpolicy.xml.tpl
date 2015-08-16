<?xml version="1.0" encoding="utf-8" ?>
<cross-domain-policy>
    <site-control permitted-cross-domain-policies="{{ flashpolicyd_permitted_cross_domain_policies }}"/>
    <allow-access-from domain="{{ flashpolicyd_allow_access_from_domain}}" to-ports="{{ flashpolicyd_allow_access_from_to_ports }}"/>
    <allow-http-request-headers-from domain="{{ flashpolicyd_allow_http_request_headers_from_domain }}" headers="{{ flashpolicyd_allow_http_request_headers_from_headers }}"/>
</cross-domain-policy>
