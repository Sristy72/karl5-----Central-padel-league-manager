# Auto-generated rules suggested by R8 (missing_rules.txt)
# Suppress warnings for classes referenced by Stripe and Kotlin Parcelize
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
-dontwarn kotlinx.parcelize.Parceler
-dontwarn kotlinx.parcelize.Parcelize

# You can add additional keep rules below if needed to retain classes used via reflection
# Example:
#-keep class com.stripe.** { *; }
