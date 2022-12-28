# AGIC

Just to keep an eye on issues.

## Alternative

This is the 'normal way to do secure AKS - [https://www.starwindsoftware.com/blog/use-an-application-gateway-as-ingress-and-protect-your-aks-websites-with-a-waf](https://www.starwindsoftware.com/blog/use-an-application-gateway-as-ingress-and-protect-your-aks-websites-with-a-waf)

Because, the WAF has the following problem...

### Slow Gateway Updates

Goood article - 
[https://medium.com/@danieljimgarcia/the-application-gateway-ingress-controller-is-broken-6aa9eb229881](https://medium.com/@danieljimgarcia/the-application-gateway-ingress-controller-is-broken-6aa9eb229881)

Tips - 
[https://azure.github.io/application-gateway-kubernetes-ingress/how-tos/minimize-downtime-during-deployments/](https://azure.github.io/application-gateway-kubernetes-ingress/how-tos/minimize-downtime-during-deployments/)

But this is the fundamental issue - 
[The AGIC design requires AppGW to make guarantees that it simply doesn’t. The design is in itself broken.](https://github.com/Azure/application-gateway-kubernetes-ingress/issues/1124#issuecomment-824595041)
