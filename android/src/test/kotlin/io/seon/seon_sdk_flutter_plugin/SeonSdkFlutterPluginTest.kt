package io.seon.seon_sdk_flutter_plugin

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.seon.androidsdk.dto.SeonGeolocationConfig
import io.seon.androidsdk.service.Seon
import io.seon.androidsdk.service.SeonBuilder
import kotlin.test.AfterTest
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import org.mockito.ArgumentCaptor
import org.mockito.MockedConstruction
import org.mockito.Mockito
import org.mockito.stubbing.Answer

internal class SeonSdkFlutterPluginTest {
  private lateinit var seon: Seon
  private lateinit var builders: MockedConstruction<SeonBuilder>
  private lateinit var plugin: SeonSdkFlutterPlugin

  @BeforeTest
  fun setUp() {
    seon = Mockito.mock(Seon::class.java)
    val fluentAnswer = Answer<Any?> { invocation ->
      val returnType = invocation.method.returnType
      when {
        returnType == Seon::class.java -> seon
        returnType.isInstance(invocation.mock) -> invocation.mock
        else -> null
      }
    }
    builders = Mockito.mockConstruction(
      SeonBuilder::class.java,
      Mockito.withSettings().defaultAnswer(fluentAnswer)
    )

    val binding = Mockito.mock(FlutterPlugin.FlutterPluginBinding::class.java)
    Mockito.`when`(binding.binaryMessenger).thenReturn(Mockito.mock(BinaryMessenger::class.java))
    Mockito.`when`(binding.applicationContext).thenReturn(Mockito.mock(Context::class.java))
    plugin = SeonSdkFlutterPlugin()
    plugin.onAttachedToEngine(binding)
  }

  @AfterTest
  fun tearDown() {
    builders.close()
  }

  private fun invoke(method: String, args: Map<String, Any?>? = null) {
    plugin.onMethodCall(MethodCall(method, args), Mockito.mock(MethodChannel.Result::class.java))
  }

  private fun onlyBuilder(): SeonBuilder {
    assertEquals(1, builders.constructed().size)
    return builders.constructed().single()
  }

  private fun geoConfigArgs() = mapOf(
    "geolocationServiceTimeoutMs" to 4000,
    "maxGeoLocationCacheAgeSec" to 100,
    "prefetchEnabled" to false,
    "geolocationEnabled" to true
  )

  @Test
  fun initialize_buildsSeonOnceWithLogging() {
    invoke("initialize")
    invoke("initialize")

    Mockito.verify(onlyBuilder()).withLogging(true)
    Mockito.verify(onlyBuilder()).build()
  }

  @Test
  fun dnsTimeoutThenSsid_usesSettersOnSingleInstance() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    Mockito.verify(seon).setDnsTimeout(3000)
    Mockito.verify(seon).setOpportunisticSsidCollectionEnabled(true)
    Mockito.verify(onlyBuilder(), Mockito.never()).withDnsTimeout(Mockito.anyInt())
    Mockito.verify(onlyBuilder(), Mockito.never())
      .withOpportunisticSsidCollectionEnabled(Mockito.anyBoolean())
  }

  @Test
  fun ssidThenDnsTimeout_usesSettersOnSingleInstance() {
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))

    Mockito.verify(seon).setOpportunisticSsidCollectionEnabled(true)
    Mockito.verify(seon).setDnsTimeout(3000)
    onlyBuilder()
  }

  @Test
  fun dnsTimeoutUpdatedTwice_setsBothValuesInOrder() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 5000))

    val inOrder = Mockito.inOrder(seon)
    inOrder.verify(seon).setDnsTimeout(3000)
    inOrder.verify(seon).setDnsTimeout(5000)
    onlyBuilder()
  }

  @Test
  fun ssidDisabledAfterEnabled_setsBothValuesInOrder() {
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to false))

    val inOrder = Mockito.inOrder(seon)
    inOrder.verify(seon).setOpportunisticSsidCollectionEnabled(true)
    inOrder.verify(seon).setOpportunisticSsidCollectionEnabled(false)
    onlyBuilder()
  }

  @Test
  fun onlyDnsTimeoutSet_ssidIsNotConfigured() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))

    Mockito.verify(seon).setDnsTimeout(3000)
    Mockito.verify(seon, Mockito.never()).setOpportunisticSsidCollectionEnabled(Mockito.anyBoolean())
  }

  @Test
  fun onlySsidSet_dnsTimeoutIsNotConfigured() {
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    Mockito.verify(seon).setOpportunisticSsidCollectionEnabled(true)
    Mockito.verify(seon, Mockito.never()).setDnsTimeout(Mockito.anyInt())
  }

  @Test
  fun missingArguments_doNotCallSetters() {
    invoke("setDnsTimeout", emptyMap())
    invoke("setOpportunisticSsidCollectionEnabled", emptyMap())

    Mockito.verify(seon, Mockito.never()).setDnsTimeout(Mockito.anyInt())
    Mockito.verify(seon, Mockito.never()).setOpportunisticSsidCollectionEnabled(Mockito.anyBoolean())
  }

  @Test
  fun geolocationConfigSetFirst_isPassedToBuilder() {
    invoke("setGeolocationConfig", geoConfigArgs())
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    val captor = ArgumentCaptor.forClass(SeonGeolocationConfig::class.java)
    Mockito.verify(onlyBuilder()).withGeoLocationConfig(captor.capture())
    assertEquals(4000, captor.value.geolocationServiceTimeoutMs)
    assertTrue(captor.value.isGeolocationEnabled())
    Mockito.verify(seon).setDnsTimeout(3000)
    Mockito.verify(seon).setOpportunisticSsidCollectionEnabled(true)
  }

  @Test
  fun geolocationConfigSetAfterSetters_updatesExistingInstance() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    invoke("setGeolocationConfig", geoConfigArgs())

    onlyBuilder()
    val captor = ArgumentCaptor.forClass(SeonGeolocationConfig::class.java)
    Mockito.verify(seon).setGeoLocationConfig(captor.capture())
    assertEquals(4000, captor.value.geolocationServiceTimeoutMs)
    assertTrue(captor.value.isGeolocationEnabled())
  }

  @Test
  fun sessionIdSetByFingerprintCall_isUsedForSingleInstance() {
    invoke("getFingerprint", mapOf("sessionId" to "session-1"))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    Mockito.verify(onlyBuilder()).withSessionId("session-1")
    Mockito.verify(seon).setSessionId("session-1")
    Mockito.verify(seon).setDnsTimeout(3000)
    Mockito.verify(seon).setOpportunisticSsidCollectionEnabled(true)
  }
}
